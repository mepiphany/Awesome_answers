json.question do
  json.title @question.title
  json.content @question.body
  json.creation_date @question.created_at.strftime("%Y-%b-%d")
  json.answer_count @question.answers.count
  json.category @question.category_name
  json.creator @question.user_full_name
  json.answers @question.answers do |answer|
    json.body answer.body
  end
  json.tags @question.tags do |tag|
    json.name tag.name
  end
end
