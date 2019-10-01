require 'rails_helper'

RSpec.describe 'Lists Create API' do
  it "can create a clients list" do
    client = create(:client)
    caretaker = create(:caretaker)

    list = {
      name: 'Groceries',
      client_id: client.id,
      caretaker_id: caretaker.id,
      created_for: 'caretaker'
    }

    headers = {
      content_type: "application/json",
      accept: "application/json"
    }

    post '/api/v1/lists', headers: headers, params: list

    expect(response).to be_successful
    expect(status).to eq(200)

    list_data = JSON.parse(response.body, symbolize_names: true)
    new_list = List.last

    expect(list_data[:name]).to eq(list[:name])
    expect(list_data[:created_for]).to eq(list[:created_for])
    expect(list_data[:client_id]).to eq(list[:client_id])
    expect(list_data[:client_name]).to eq(client.name)
    expect(list_data[:caretaker_name]).to eq(caretaker.name)
    expect(list_data[:caretaker_id]).to eq(list[:caretaker_id])
    expect(list_data).to have_key(:created_at)
    expect(list_data).to have_key(:updated_at)

    expect(new_list.id).to eq(list_data[:id])
  end

  it "cant create a clients list without client" do
    client = create(:client)
    caretaker = create(:caretaker)

    list = {
      name: 'Groceries',
      caretaker_id: caretaker.id
    }

    headers = {
      content_type: "application/json",
      accept: "application/json"
    }

    post '/api/v1/lists', headers: headers, params: list

    errors = JSON.parse(response.body, symbolize_names: true)

    expect(status).to eq(400)

    expect(errors[:client]).to eq(['must exist'])
  end
end
