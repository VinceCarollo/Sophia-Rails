class ListSerializer
  def initialize(list)
    @id = list.id
    @name = list.name
    @client_id = list.client_id
    @created_at = list.created_at
    @updated_at = list.updated_at
    @caretaker_id = list.caretaker_id
    @client_name = list.client.name
    @caretaker_name = get_optional_caretaker(list.caretaker)
  end

  private

  def get_optional_caretaker(caretaker)
    if caretaker
      caretaker.name
    else
      nil
    end
  end
end
