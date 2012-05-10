Meteor.startup ->
  if Rooms.find().count() is 0
    Rooms.insert
      name: "Off Topic"
