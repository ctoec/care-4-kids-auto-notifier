# Upgrading to Rails 6.0

## Context
`DelayedJob` requires that job parameters be serialized for storage in a database. The parameters needed in our architectural structure are `Sender` objects and `Struct`s. Rails 5.2 does not support serialization of custom classes or objects. Upon investigation of Github Issues and [PRs](https://github.com/rails/rails/pull/30941), custom serializes would not be available until Rails 6.0. Alternatively, the application architecture could be changed so as to not require the serialization of custom classes and objects.

Rails 6.0 left beta and was released a few days prior to the investigation work on serialization.

United Way does not currently have any applications running Rails 6.0.

## Decision
The team decided to upgrade to Rails 6.0.

The team felt that given:
* Rails 6.0 was no longer in beta
* Rails provides good upgrade transition documentation
* Factoring in the cost of an application architecture rewrite
* United Way gave its blessing to use Rails 6.0
The benefits of using Rails 6.0 superceded the lack of current institutional support in United Way.

## Status
* Proposed
* __Accepted__
* Rejected
* Superceded
* Accepted (Partially superceded)

## Consequences

United Way needs to set up a new environment with Rails 6.0 installed.