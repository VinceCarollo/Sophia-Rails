require 'rails_helper'

RSpec.describe "Client Index API" do
  it "gets all clients" do
    client1 = create(:client)
    client2 = create(:client)
    client3 = create(:client)

    headers = {
      content_type: 'application/json',
      accept: 'application/json'
    }

    get '/api/v1/clients', headers: headers

    expect(response).to be_successful
    expect(status).to eq(200)

    clients_data = JSON.parse(response.body, symbolize_names: true)

    expect(clients_data).to be_a Array
    expect(clients_data.count).to eq(3)

    expect(clients_data.first).to have_key(:username)
    expect(clients_data.first).to have_key(:name)
    expect(clients_data.first).to have_key(:street_address)
    expect(clients_data.first).to have_key(:city)
    expect(clients_data.first).to have_key(:state)
    expect(clients_data.first).to have_key(:zip)
    expect(clients_data.first).to have_key(:email)
    expect(clients_data.first).to have_key(:phone_number)
    expect(clients_data.first).to have_key(:needs)
    expect(clients_data.first[:needs]).to be_a Array
    expect(clients_data.first).to have_key(:allergies)
    expect(clients_data.first[:allergies]).to be_a Array
    expect(clients_data.first).to have_key(:medications)
    expect(clients_data.first[:medications]).to be_a Array
    expect(clients_data.first).to have_key(:diet_restrictions)
    expect(clients_data.first[:diet_restrictions]).to be_a Array
    expect(clients_data.first).to have_key(:role)
  end
end
