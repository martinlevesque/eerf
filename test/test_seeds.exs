IO.puts "im seeding..."

Eerf.Repo.query("TRUNCATE users", [])


# Eerf.Repo.insert!(%Eerf.SomeSchema{})
Eerf.Repo.insert!(%Eerf.Auth.User{
  email: "hello@world.com",
  username: "helloworld",
  password: "12345678"
})
