class ChangeSeatTypeInTickets < ActiveRecord::Migration
  def up
    change_column(:tickets,:name_of_seat, :integer)
  end

  def down
    change_column(:tickets,:name_of_seat, :string)
  end
end

