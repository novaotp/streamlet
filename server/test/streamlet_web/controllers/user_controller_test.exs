defmodule StreamletWeb.UserControllerTest do
  use StreamletWeb.Support.ConnCase
  use Streamlet.Support.DataCase

  import Streamlet.Support.AuthFixtures

  setup do
    truncate_db!()

    conn =
      build_conn()
      |> put_req_header("accept", "application/json")
      |> put_req_header("content-type", "application/json")

    %{conn: conn}
  end

  describe "GET /api/users/me" do
    test "returns 401 if not logged in", %{conn: conn} do
      body =
        conn
        |> get(~p"/api/users/me")
        |> json_response(401)

      assert %{"message" => "You must be authenticated."} = body
    end

    test "returns 200 otherwise", %{conn: conn} do
      user = user_fixture()

      body =
        conn
        |> log_in_user(user)
        |> get(~p"/api/users/me")
        |> json_response(200)
        |> Map.get("data")

      email = user.email
      assert %{
          "username" => nil,
          "email" => ^email,
          "inserted_at" => _
        } = body
    end
  end
end
