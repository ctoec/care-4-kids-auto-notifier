# Application Flow Architecture

## Context
There were two developers (Gabriel and Cailyn) who began coding on this project. They desired to split the work between themselves without substantial overlap or dependency on each other. The developers also wanted to employ Test-Driven Development and ensure that all components were individually testable.

The developers also want each component to be configurable, enabling fakes to be used in testing and to employ dependency injection.

A central precept of testing is that one shouldn't test code they don't own.

## Decision
The team decided to create three surfaces in which work would intergrate at two points: United Way Database <--> Notification Generation <--> Notification Transmission.

The touch point between United Way Database and Notification Generator is the `DocumentAssignedEventsRepository` class.
The touch point between Notification Generator and Notification Transmission is the `NotificationQueue` class.

`ActiveJob` and the `Twilio` client are wrapped in singleton classes, `NotificationSendJob` and `TwilioSender`, respectively, to ensure testability.

`NotificationQueue` is parameterized on:
* Job scheduling wrapper
* Sending wrapper
* Scheduling wrapper

`NotificationGenerator` is parameterized on a database wrapper.

`NotificationManager` is parameterized on a messaging queue and notification generator.

See `high-level-design_09-09-19.md` for additional details.

## Status
* Proposed
* __Accepted__
* Rejected
* Superceded
* Accepted (Partially superceded)

## Consequences
Developers were able to program wishfully, establishing implicit interfaces what allowed a) ease of integration and b) self-contained development and testing.