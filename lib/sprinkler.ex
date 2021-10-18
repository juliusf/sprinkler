defmodule Sprinkler do
  @moduledoc """
  Documentation for `Sprinkler`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Sprinkler.hello()
      :world

  """
  alias Sippet.Transports, as: Transports
  use Application
  use Sippet.Core

  def start(_type, _args) do
    IO.puts "starting"
    Sippet.start_link(name: :mystack)
    Sippet.Transports.UDP.start_link(name: :mystack)
    Sippet.register_core(:mystack, Sprinkler)
    children = []
    Supervisor.start_link(children, strategy: :one_for_one)
  end  

  def receive_request(incoming_request, server_key) do
    IO.puts "received request:"  
    #IO.puts(incoming_request)
    Sippet.send(:mystack, incoming_request)
  end

  def receive_response(incoming_response, client_key) do
    # route the response to your UA or proxy process
    IO.puts "received response:"
    #IO.puts incoming_response
    Sippet.send(:mystack, incoming_response)
  end

  def receive_error(reason, client_or_server_key) do
    # route the error to your UA or proxy process
    IO.puts reason
    IO.puts client_or_server_key
  end
end
