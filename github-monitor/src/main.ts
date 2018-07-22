"use strict";

import * as octorest from '@octokit/rest'
import * as https from 'https'

const octokit = new octorest()

octokit.repos.getLatestRelease({
    owner: "mholt",
    repo: "caddy"
  }).then(({data, headers, status}) => {
    console.log("Release name: " + data.name)
    console.log("Git tag: " + data.tag_name)
  })

https.get('https://hub.docker.com/v2/repositories/2innovate/2i-web/tags/', (res) => {
    res.setEncoding("utf8");
    let body = "";
    res.on("data", data => {
      body += data;
    });
    res.on("end", () => {
      let bodyJSON: any = JSON.parse(body);
      console.log(`Count: ${bodyJSON.count}`)
      for (var r of bodyJSON.results) {
          console.log(`Tag name: ${r.name}`)
      }
    });
  });
  