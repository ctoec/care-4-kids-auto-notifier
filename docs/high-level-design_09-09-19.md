# High Level Architectural Design

## Structure

This application is derived from the standard Rails installation. However, it does not rely on the front-end facing components, such as assests, controllers, and views.
* Code pertaining to the tranmission of notifications lives in the `app/notification` folder
* Code for interacting with the United Way database and configuring SMS notifications lives in `app/parent_notifications`
* Serializers used by `DelayedJob` live in `app/serializers`
* Scripts for initialization of databases, starting the program, and configuring runtime instantization live in `scripts`.

## Data Structure

There are three project-specific `ActiveRecord` models in use.

* Notification
* Parent
* EventCursor

`Notification`s represent the SMS message text that is used to send to parents. The message text includes document types, source of receipt, and an approximation of date of receipt. Thus, pursuant to OEC-requirements, the message text is encrytped at rest.

`Parent`s represent the applications to the Care 4 Kids program. This model includes their phone number to receive SMS messages and their Care 4 Kids assigned Case ID.

`EventCursor` represents the date/time that was last used to query for new document assigned events. There is only ever one record in this table.

## Application Flow

The application kicks off by calling the `NotificationRunner.schedule_notifications` class method. This is supplied a `Sender` object. The `Sender` object is a singleton that wraps a SMS sending SDK, in our case Twilio.

The `NotificationRunner` also configures the `NotificationQueue`, `NotificationGenerator`, and `NotificationManager`. We will address each of these in turn.

### NotificationQueue

The `NotificationQueue` provides an I/O-esque interface (`#put`) for enqueueing notifications to be sent. It is effectively a configurable wrapper to a `Scheduler` object.

### NotificationGenerator

The `NotificationGenerator`, through the `fetch_all_new` instance method, retrives document assigned events from the United Way database that have occurred since the last query. From the results of this query, it constructs `NotificationEvents`, which are passed in-memory to the invoking-class `NotificationManager`.

### NotificationManager

The `NotificationManager` invokes the `NotificationGenerator#run` instance method. This method calls `NotificationGenerator#fetch_all_new` instance method and passes the results to the `NotificationQueue#put` method.


Now that we've addressed these objects, let's return to the `Scheduler` object. The `Scheduler` object is itself a wrapper of the `ActiveJob` construct. It is a singleton that abstracts away the timing concerns of job scheduling. The Care 4 Kids program, as required by OEC, is only allowed to send SMSes between 8am and 9pm. The `WakingHoursScheduler` encodes this logic.