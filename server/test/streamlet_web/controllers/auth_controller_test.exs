defmodule StreamletWeb.AuthControllerTest do
  use StreamletWeb.Support.ConnCase
  use Streamlet.Support.DataCase

  import Streamlet.Support.AuthFixtures
  alias Streamlet.Constants

  @attrs %{email: "user@example.com", password: "userexample"}
  @invalid_register_attrs %{username: "a", email: "userexample.com", password: "u"}
  @invalid_login_attrs %{email: "userexample.com", password: "u"}

  setup do
    truncate_db!()

    conn =
      build_conn()
      |> put_req_header("accept", "application/json")
      |> put_req_header("content-type", "application/json")

    %{conn: conn}
  end

  describe "POST /api/auth/register" do
    test "returns 422 if body is invalid", %{conn: conn} do
      body =
        conn
        |> post(~p"/api/auth/register", @invalid_register_attrs)
        |> json_response(422)

      assert %{
          "message" => "Invalid data.",
          "errors" => %{}
        } = body
    end

    test "returns 201 otherwise", %{conn: conn} do
      conn = post(conn, ~p"/api/auth/register", @attrs)

      assert %{"message" => "Registered successfully."} = json_response(conn, 201)
      assert has_session_token_cookie(conn)
    end
  end

  describe "POST /api/auth/login" do
    test "returns 401 if user does not exist", %{conn: conn} do
      body =
        conn
        |> post(~p"/api/auth/login", @attrs)
        |> json_response(401)

      assert %{"message" => "Invalid email or password."} = body
    end

    test "returns 401 if body is invalid", %{conn: conn} do
      _user = user_fixture(@attrs)

      body =
        conn
        |> post(~p"/api/auth/login", @invalid_login_attrs)
        |> json_response(401)

      assert %{"message" => "Invalid email or password."} = body
    end

    test "returns 200 otherwise", %{conn: conn} do
      _user = user_fixture(@attrs)

      conn = post(conn, ~p"/api/auth/login", @attrs)

      assert %{"message" => "Logged in successfully."} = json_response(conn, 200)
      assert has_session_token_cookie(conn)
    end
  end

  describe "POST /api/auth/logout" do
    test "returns 204 if there is no session token cookie", %{conn: conn} do
      conn =
        conn
        |> put_req_cookie("unrelated_cookie", "value")
        |> post(~p"/api/auth/logout")

      assert response(conn, 204) == ""
      assert get_cookies(conn) == %{"unrelated_cookie" => "value"}
    end

    test "returns 204 if there is a session token cookie", %{conn: conn} do
      user = user_fixture()

      conn =
        conn
        |> put_req_cookie("unrelated_cookie", "value")
        |> log_in_user(user)
        |> post(~p"/api/auth/logout")

      assert response(conn, 204) == ""
      assert get_cookies(conn) == %{"unrelated_cookie" => "value"}
    end
  end

  defp has_session_token_cookie(conn) do
    conn
    |> get_cookies()
    |> Map.has_key?(Constants.session_token_cookie_name())
  end
end
