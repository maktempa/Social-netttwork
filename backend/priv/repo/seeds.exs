# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Backend.Repo.insert!(%Backend.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# use Backend.Model # doesn't work - need to be in module
import Ecto.Query
alias Backend.{Repo, User, Friendship}

IO.puts("Importing Model")
Repo.insert!(%Backend.User{login: "name1", city: "Moscow"})
Repo.insert!(%Backend.User{login: "name2", password: "Password2"})
Repo.insert!(%Backend.User{login: "name3", password: "Password3"})
Repo.insert!(%Backend.User{login: "name4", password: "Password3"})
Repo.insert!(%Backend.User{login: "name5", password: "Password3"})
Backend.User.create(%{login: "name6", password: "Ppassword1"})

r1 = Backend.Repo.get(Backend.User, 1)
r2 = Backend.Repo.get(Backend.User, 2)
r3 = Backend.Repo.get(Backend.User, 3)
r4 = Backend.Repo.get(Backend.User, 4)
r5 = Backend.Repo.get(Backend.User, 5)

Backend.Friendship.create(r2, r1)
Backend.Friendship.create(r3, r1)
Backend.Friendship.create(r3, r4)
Backend.Friendship.create2(r3.id, r5.id)
# Backend.Friendship.create(rq, rs)
# Backend.Repo.all(from f in Backend.Friendship, select: f)
# fr = Backend.Repo.all(from u in Backend.User, preload: [:possible_friends])
# fr = Backend.Repo.all(from u in Backend.User, join: f in  Backend.Friendship,
#   where: u.id==f.requester_user_id or u.id==f.respondent_user_id, distinct: true)
# fr = Backend.Repo.all(from u in Backend.User, join: f in  Backend.Friendship,
#   where: u.id==f.requester_user_id or u.id==f.respondent_user_id , preload: [:possible_friends], distinct: :true)





IO.puts("#{inspect(Backend.Repo.all(from f in Backend.Friendship, select: f))}")
IO.puts("\n #{inspect(Backend.Repo.all(from u in Backend.User, select: u))}")
fr = Backend.Repo.all(from u in Backend.User, join: f in  Backend.Friendship, where: u.id==f.requester_user_id or u.id==f.respondent_user_id )
