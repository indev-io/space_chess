defmodule SpaceChess.Email do
  import Swoosh.Email

  def welcome(user) do
    new()
    |> to({user.name, user.email})
    |> from({"Devnaut", "devnaut@gmail.com"})
    |> subject("Hello, Avengers!")
    |> html_body("<h1>Hello #{user.name}</h1>")
    |> text_body("Hello #{user.name}\n")
  end
end
