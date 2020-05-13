# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PlayItCool.Repo.insert!(%PlayItCool.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

PlayItCool.Repo.insert!(%PlayItCool.User{
  email: "test@test.com",
  password: "testpassword",
  username: "testuser",
  lowercase_username: "testuser"
})

subject = PlayItCool.Repo.insert!(%PlayItCool.Subject{label: "food"})

PlayItCool.Repo.insert_all(PlayItCool.Question, [
  %{
    question: "What is 1?",
    subject_id: subject.id,
    inserted_at: ~N[2020-03-03 12:00:00],
    updated_at: ~N[2020-03-03 12:00:00]
  },
  %{
    question: "What is 2?",
    subject_id: subject.id,
    inserted_at: ~N[2020-03-03 12:00:00],
    updated_at: ~N[2020-03-03 12:00:00]
  },
  %{
    question: "What is 3?",
    subject_id: subject.id,
    inserted_at: ~N[2020-03-03 12:00:00],
    updated_at: ~N[2020-03-03 12:00:00]
  },
  %{
    question: "What is 4?",
    subject_id: subject.id,
    inserted_at: ~N[2020-03-03 12:00:00],
    updated_at: ~N[2020-03-03 12:00:00]
  },
  %{
    question: "What is 5?",
    subject_id: subject.id,
    inserted_at: ~N[2020-03-03 12:00:00],
    updated_at: ~N[2020-03-03 12:00:00]
  },
  %{
    question: "What is 6?",
    subject_id: subject.id,
    inserted_at: ~N[2020-03-03 12:00:00],
    updated_at: ~N[2020-03-03 12:00:00]
  },
  %{
    question: "What is 7?",
    subject_id: subject.id,
    inserted_at: ~N[2020-03-03 12:00:00],
    updated_at: ~N[2020-03-03 12:00:00]
  }
])

PlayItCool.Repo.insert_all(PlayItCool.Word, [
  %{
    word: "Banana",
    subject_id: subject.id,
    inserted_at: ~N[2020-03-03 13:00:00],
    updated_at: ~N[2020-03-03 13:00:00]
  },
  %{
    word: "Apple",
    subject_id: subject.id,
    inserted_at: ~N[2020-03-03 13:00:00],
    updated_at: ~N[2020-03-03 13:00:00]
  },
  %{
    word: "Mushroom soup",
    subject_id: subject.id,
    inserted_at: ~N[2020-03-03 13:00:00],
    updated_at: ~N[2020-03-03 13:00:00]
  },
  %{
    word: "Popcorn",
    subject_id: subject.id,
    inserted_at: ~N[2020-03-03 13:00:00],
    updated_at: ~N[2020-03-03 13:00:00]
  },
  %{
    word: "Taco",
    subject_id: subject.id,
    inserted_at: ~N[2020-03-03 13:00:00],
    updated_at: ~N[2020-03-03 13:00:00]
  },
  %{
    word: "Sushi",
    subject_id: subject.id,
    inserted_at: ~N[2020-03-03 13:00:00],
    updated_at: ~N[2020-03-03 13:00:00]
  },
  %{
    word: "Ramen",
    subject_id: subject.id,
    inserted_at: ~N[2020-03-03 13:00:00],
    updated_at: ~N[2020-03-03 13:00:00]
  }
])
