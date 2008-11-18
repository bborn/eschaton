class MatchData # :nodoc:
  
  # Returns the group at the given +position+, which is zero based.
  #   match = "Group1 Group2 Group3".match(/(\w+) (\w+) (\w+)/)  
  #   match.group(0) #=> 'Group1'
  #   match.group(1) #=> 'Group2'
  #   match.group(2) #=> 'Group3'
  def group(position)
    self[position + 1]
  end
  
end