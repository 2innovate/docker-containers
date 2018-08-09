"use strict";

import * as octorest from '@octokit/rest'
import * as https from 'https'
import * as git from 'simple-git/promise'

const originRemote = "https://2innovate:" + process.env["GITHUB_AUTHTOKEN"] + "@github.com/2innovate/caddy-docker";
const upstreamRemote = "https://github.com/abiosoft/caddy-docker";
const workingDir = "caddy-docker-repo"

async function getLatestCaddyRelease() {
  const octokit = new octorest()

  octokit.repos.getLatestRelease({
      owner: "mholt",
      repo: "caddy"
    }).then(({data, headers, status}) => {
      tagExistsInDockerHub(data.tag_name);
    })
}

function tagExistsInDockerHub(tagName) {
  https.get('https://hub.docker.com/v2/repositories/2innovate/caddy/tags/', (res) => {
    res.setEncoding("utf8");
    let body = "";
    res.on("data", data => {
      body += data;
    });
    res.on("end", () => {
      let bodyJSON: any = JSON.parse(body);
      for (var r of bodyJSON.results) {
        if (r.name == tagName) {
          // Tag already exists, so we exit
          return(true);
        }
      }
      // Tag not found, so we create it
      createNewBranch(workingDir, tagName);
    });
  });
}

async function createNewBranch(workingDir, release) {
  try {
    await git().silent(false).clone(originRemote, workingDir);
    await git(workingDir).addRemote("upstream", upstreamRemote);
    await git(workingDir).checkout('master');
    await git(workingDir).pull("upstream", "master");
    await git(workingDir).push("origin", "master");
    await git(workingDir).push("origin", `master:${release}`);
  } catch(err) {
    console.error('failed: ', err);
    process.exit(2);
  }
}

getLatestCaddyRelease().catch((err) => {console.error('failed: ', err); process.exit(1)});
