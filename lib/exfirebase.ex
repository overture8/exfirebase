defmodule ExFirebase do
  @moduledoc """
  Provides interfaces for Firebase API calls.
  Also, the following modules provides object-based operation interface.

    - ExFirebase.Records : Helper for Elixir's record-based operations
    - ExFirebase.Objects : Helper for getting/posting objects
  """
  alias ExFirebase.HTTP

  @doc """
  Setup base url for Firebase (https://xxx.firebaseio.com/).
  """
  def set_url(url) do
    ExFirebase.Setting.set_url(url)
  end

  @doc """
  Get json url for the specified path concatinated with the
  prespecified base url.
  """
  def get_url(path) do
    ExFirebase.Setting.get_url(path)
  end

  @doc """
  Setup auth token for accesing the API.
  """
  def set_auth_token(token) do
    ExFirebase.Setting.set_auth_token(token)
  end

  @doc """
  Returns auth token previously specified with 'set_auth_token'
  """
  def get_auth_token do
    ExFirebase.Setting.get_auth_token
  end

  @doc """
  Get objects on the specified path.
  """
  def get(path // "") do
    send_request(path, &HTTP.get/1)
  end

  @doc """
  Put specified object.
  It replaces the data on the specified path.
  """
  def put(path, object) do
    send_request(path, &HTTP.put/2, object)
  end

  @doc """
  Post specified object.
  It appends the data to the specified path.
  """
  def post(path, object) do
    send_request(path, &HTTP.post/2, object)
  end

  @doc """
  Update data on the specified path with the specified object.
  """
  def patch(path, object) do
    send_request(path, &HTTP.patch/2, object)
  end

  @doc """
  Delete objects on the specified path.
  """
  def delete(path) do
    send_request(path, &HTTP.delete/1)
  end

  @doc """
  Get objects on the specified path in raw json format.
  Options can be used to provide additional parameter for requqest.

    - options[pretty: true] : Specify 'print=pretty' for human readable format.
  """
  def get_raw_json(path // "", options // nil) do
    HTTP.get(get_url(path) <> parse_option_url(options))
  end

  @doc """
  Send the request to server and returns response in tuple/list format
  """
  def send_request(path, method) do
    method.(get_url(path)) |> parse_json
  end

  @doc """
  Send the request to server and returns response in tuple/list format
  """
  def send_request(path, method, data) do
    method.(get_url(path), JSON.generate(data)) |> parse_json
  end

  defp parse_option_url(nil), do: ""
  defp parse_option_url(options) do
    if options[:pretty] == true do
      "?print=pretty"
    else
      ""
    end
  end

  defp parse_json("null"), do: []
  defp parse_json(string), do: JSON.parse(string)
end
