class Api::V1::ListsController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }

  def index
    client = find_client
    caretaker = find_caretaker
    render_lists(client, caretaker)
  end

  def show
    list = List.find(params[:id])
    render json: ListSerializer.new(list)
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'List Not Found' }, status: 404
  end

  def create
    list = List.new(list_params)
    if list.save
      render json: ListSerializer.new(list)
    else
      render json: list.errors, status: 400
    end
  end

  def update
    list = List.find(params[:id])
    list.update_attributes({name: params[:name]})
    render json: ListSerializer.new(list)
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'List Not Found' }, status: 404
  end

  def destroy
    list = List.find(params[:id])
    list.destroy
    render json: {}, status: 204
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'List Not Found' }, status: 404
  end

  private

  def list_params
    params.permit(:name, :client_id, :caretaker_id)
  end

  def render_lists(client, caretaker)
    if client
      render json: client.lists.map{|list| ListSerializer.new(list)}
    elsif caretaker
      render json: caretaker.lists.map{|list| ListSerializer.new(list)}
    else
      render json: { message: 'Not Found' }, status: 404
    end
  end

  def find_client
    Client.find(params[:client_id])
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def find_caretaker
    Caretaker.find(params[:caretaker_id])
  rescue ActiveRecord::RecordNotFound
    nil
  end
end
