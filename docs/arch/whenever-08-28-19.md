# Upgrading to Whenever

## Context
[Whenever](https://github.com/javan/whenever) is tool for for setting up and managing cron.

## Decision
The lead developer of UnitedWay suggested using whenever to manage cron tasks.

The team felt that given:
* Whenever is a generally accepted and supported tool in the rails and ruby community
* Whenever is familiar to and supported by UnitedWay
* It makes setting up and tearing down cronjobs for deployment an automated process that can be documented in code

## Status
* Proposed
* __Accepted__
* Rejected
* Superceded
* Accepted (Partially superceded)

## Consequences
- We depend on cron
- We had to install [dotenv](https://github.com/bkeepers/dotenv) to ensure that our env variables are picked up by the app.
- If we want to deploy to another service like Heroku or Lambda that does not use cron we will need to change our application architecture.
