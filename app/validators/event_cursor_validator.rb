class EventCursorValidator < ActiveModel::Validator 
  def validate(event_cursor)
      unless EventCursor.all.length == 0
        event_cursor.errors[:base] << 'Another event cursor already exists. There can be only one.'
  end
end