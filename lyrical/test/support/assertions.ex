defmodule Lyrical.Assertions do
  ## Join Replies 
  def assert_valid_payload({:ok, payload, %Phoenix.Socket{}} = reply) do
    assert_payload(payload)
    reply
  end

  def assert_valid_payload({:error, _reason} = reply), do: reply

  ## Socket Messages
  def assert_valid_payload(%Phoenix.Socket.Message{payload: payload}) when is_map(payload) do
    assert_payload(payload)
  end

  def assert_valid_payload(%Phoenix.Socket.Message{payload: {:binary, data}})
      when is_binary(data) do
    :ok
  end

  def assert_valid_payload(%Phoenix.Socket.Message{payload: payload}) do
    raise ExUnit.AssertionError,
      expr: payload,
      message:
        "Payload must be a JSON-serializable map or a tagged {:binary, data} tuple where data is binary data."
  end

  ## Helpers

  defp assert_payload(payload) do
    case Jason.encode(payload) do
      {:ok, _} ->
        :ok

      {:error, error} ->
        raise ExUnit.AssertionError,
          expr: payload,
          message: "Map must be JSON-serializable. Got error: #{inspect(error)}"
    end
  end
end
