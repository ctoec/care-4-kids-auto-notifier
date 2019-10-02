# Using Capistrano

## Context
[Capistrano](https://capistranorb.com/) is tool for deploy ruby applications.

## Decision
The lead developer of UnitedWay suggested using capistrano for deployments.

The team felt that given:
* Capistrano is a generally accepted and supported tool in the rails and ruby community
* Capistrano is familiar to and supported by UnitedWay
* The tool made is easier to redeploy whenever and delay_job.

## Status
* Proposed
* __Accepted__
* Rejected
* Superceded
* Accepted (Partially superceded)

## Consequences
- We depend on an ageing tool, newer deployment systems like kubernetes and heroku do not use capistrano
- Many of the deployment processes are automatically generated making deployments a black box, which does not allow for fine-tuning. 