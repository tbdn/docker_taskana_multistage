# Docker Multistage for TASKANA
The goal of this multistrage dockerfile is to clone, build and run TASKANA inside a docker container based on alpine

## Prerequisites
- Docker

## Components
* [TASKANA](https://github.com/taskana/taskana) - The open source task management library
* Maven
* Angular

# How to run
* docker build -t taskana_multistage .
* docker run -p 8080:8080 taskana_multistage