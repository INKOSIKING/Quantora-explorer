package platform.security

default allow = false

allow {
  input.method == "GET"
  input.path = ["healthz"]
}

allow {
  input.method == "POST"
  input.path = ["auth", "login"]
}

allow {
  input.jwt.payload.roles[_] == "admin"
}