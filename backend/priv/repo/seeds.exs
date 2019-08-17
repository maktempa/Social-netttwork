# use Backend.Model # doesn't work - need to be in module
import Ecto.Query
alias Backend.Repo

IO.puts("Importing Model")
Repo.insert!(%Backend.User{login: "name1", password: "Password1"})
Repo.insert!(%Backend.User{login: "name2", password: "Password2"})
Repo.insert!(%Backend.User{login: "name3", password: "Password3"})

rs = Backend.Repo.get(Backend.User, 1)
rq1 = Backend.Repo.get(Backend.User, 2)
rq2 = Backend.Repo.get(Backend.User, 3)
Backend.Friendship.create(rq1, rs)
Backend.Friendship.create(rq2, rs)
# Backend.Friendship.create(rq, rs)
# Backend.Repo.all(from f in Backend.Friendship, select: f)
# fr = Backend.Repo.all(from u in Backend.User, preload: [:possible_friends])
