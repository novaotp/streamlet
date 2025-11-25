defmodule StreamletWeb.ChannelControllerTest do
  use StreamletWeb.ConnCase

  alias Streamlet.AuthHelpers

  describe "GET /api/channels" do
    test "returns an empty list if there are no channels" do
      conn =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> get("/api/channels")

      body = json_response(conn, 200)

      assert %{"data" => []} = body
    end
  end

  describe "POST /api/channels" do
    test "returns 401 if unauthenticated" do
      conn =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("content-type", "application/json")
        |> put_req_cookie
        |> post("/api/channels", %{})

      assert %{"message" => _} = json_response(conn, 401)
    end

    test "returns F else" do
      conn =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("content-type", "application/json")
        |>
        |> post("/api/channels", %{})

      assert %{"message" => _} = json_response(conn, 401)
    end

    # test "returns 422 if the required parameters are missing" do
    #   data = %{}

    #   conn =
    #     build_conn()
    #     |> put_req_header("accept", "application/json")
    #     |> put_req_header("content-type", "application/json")
    #     |> post("/api/channels", data)

    #   body = json_response(conn, 422)

    #   assert %{"message" => _, "errors" => errors} = Jason.decode(conn.resp_body)
    #   assert %{"errors" => }
    # end
  end
end
