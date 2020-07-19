# Testing and Integration Notes

# Available Solutions

## The Need

- Speed
    - Build frequently and faster
- Automation
    - Build and deploy in an automated fashion
- Predictable results
    - Test each step and deploy only if everything is okay
- Faster time-to-market
    - Possibility to deliver to production at any time

## Solutions

- Buildbot
    - http://buildbot.net/
    - Free
- TeamCity
    - https://www.jetbrains.com/teamcity/ 
    - Paid and Free
- Bamboo
    - https://www.atlassian.com/software/bamboo 
    - Only paid
- Hudson
    - http://hudson-ci.org/
    - Free
    - Backed by Eclipse and Oracle
- Jenkins
    - https://jenkins.io/ 
    - Free (and Paid)
    - Backed by CloudBees

## Main Definitions

- Continuous Delivery and Integration
    - CD is the ability to release at any time
    - CI is practice of integrating or merging code changes frequently  
- Stages of CD and CI
    - Build => Deploy => Test => Release

## CD vs CD

- Continuous Delivery
    - Software can be released to production at any time
    - Every change can go to production
    - I could be deploying constantly

- Continuous Deployment
    - Software is released to production as part of an automated pipeline
    - Every change goes to production
    - I am deploying constantly       

# Introduction to Jenkins

## What is Jenkins?

- An open source automation server
- A platform for the Software Development Life Cycle (SDLC)
- Typically used to implement CI/CD
- Easy to use and highly adaptable
- Extensible and customizable
- Works on most common operating systems
- Considered lightweight

## Key Definitions

- Job
    - Configured task in Jenkins. It is an old term
- Project
    - A task configured in Jenkins. It is the current term
- Pipeline
    - Special type of job created by a Pipeline plugin

## Requirements and Installation

- Requirements
    - Works on Unix / Linux / Mac / Windows
    - Requires Java 7 or 8
- Installation
    - Can be installed as a Native Service, Container, Java application
    - Can be installed from source or through package system

# Advanced Jenkins