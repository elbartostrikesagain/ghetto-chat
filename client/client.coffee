#Define Backbone Router
RoomsRouter = Backbone.Router.extend(
  routes:
    ":room_id": "main"

  main: (room_id) ->
    Session.set "room_id", room_id

  setRoom: (room_id) ->
    @navigate(room_id, true)
)

#Create Router
Router = new RoomsRouter

#run after DOM is loaded every time
Meteor.startup ->
  Backbone.history.start pushState: true

###########
#Functions#
###########

sendMessage = ->
  room_id = Session.get("room_id")
  current_room = Rooms.findOne(_id: room_id)
  username = $('#user-name').val()
  text = $('#chat-input-text').val()
  if current_room && username && text
    chat_text = "\n" + username + ": " + text
    $('#room-text').val(current_room.text + chat_text)
    sel = _id: Session.get("room_id")
    mod = $set: text: $('#room-text').val()
    Rooms.update(sel, mod)

###########
#Templates#
###########

#roomList
Template.roomList.rooms = ->
  Rooms.find({},
    sort:
      name: 1
  )
Template.roomList.events = 
  'click #new-room': (e) ->
    name = $('#new-room-name').val()
    if name
      Rooms.insert(
        name: name
        text: ""
      )

#room
Template.room.events = 
  'click #delete-room': (e) ->
    Rooms.remove(@_id)
  'click #edit-room': (e) ->
    Router.setRoom(@_id)

Template.room.selected = ->
    if Session.equals("room_id", @_id) then "selected" else ""

#roomView
Template.roomView.selectedRoom = ->
  room_id = Session.get("room_id")
  selected = Rooms.findOne(
    _id: room_id
  )
  if selected
    # This shouldn't be necessary, but otherwise the value doesn't update correctly
    $('#room-text').val(selected.text)
    selected

Template.roomView.events = 
  'keyup #room-text': (e) ->
    # @_id should work here, but it doesn't
    sel = _id: Session.get("room_id")
    mod = $set: text: $('#room-text').val()
    Rooms.update(sel, mod)

  'keyup #chat-input-text': (e) ->
    if e.keyCode == 13
      sendMessage()

  'click #chat-input': (e) ->
    sendMessage()