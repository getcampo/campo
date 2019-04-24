json.id @post.id
json.url topic_path(@post.topic, number: @post.number)
json.body markdown_render(@post.body)
json.summary truncate(strip_tags(markdown_render(@post.body)), length: 140)
json.user do
  json.name @post.user.name
  json.username @post.user.username
  json.avatar_url url_for(@post.user.avatar)
end
