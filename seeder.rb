require 'pg'
require 'faker'
require 'pry'

TITLES = ["Roasted Brussels Sprouts",
  "Fresh Brussels Sprouts Soup",
  "Brussels Sprouts with Toasted Breadcrumbs, Parmesan, and Lemon",
  "Cheesy Maple Roasted Brussels Sprouts and Broccoli with Dried Cherries",
  "Hot Cheesy Roasted Brussels Sprout Dip",
  "Pomegranate Roasted Brussels Sprouts with Red Grapes and Farro",
  "Roasted Brussels Sprout and Red Potato Salad",
  "Smoky Buttered Brussels Sprouts",
  "Sweet and Spicy Roasted Brussels Sprouts",
  "Smoky Buttered Brussels Sprouts",
  "Brussels Sprouts and Egg Salad with Hazelnuts"]

#WRITE CODE TO SEED YOUR DATABASE AND TABLES HERE

def db_connection
  begin
    connection = PG.connect(dbname: "brussels_sprouts_recipes")
    yield(connection)
  ensure
    connection.close
  end
end


COMMENTS = []

50.times do
  COMMENTS << Faker::Lorem.sentence(2)
end

db_connection do |conn|
  conn.exec("DROP TABLE IF EXISTS recipes;

  CREATE TABLE recipes (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100)
  );

  DROP TABLE IF EXISTS comments;

  CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    comment VARCHAR(255),
    recipe_id INTEGER
  );")
end

TITLES.each do |title|
  db_connection do |conn|
    conn.exec_params("INSERT INTO recipes (title)
    VALUES ($1)", [title])
  end
end

#1

db_connection do |conn|
  @recipe_count = conn.exec("SELECT count(*) FROM recipes;")
end


@recipe_count.each do |count|
  @recipe_count_int = count["count"].to_i
end

puts "#{@recipe_count_int}"

COMMENTS.each do |comment|
  db_connection do |conn|
    conn.exec_params("INSERT INTO comments (comment, recipe_id)
    VALUES ($1, $2);", [comment, (rand(@recipe_count_int)+1)])
  end
end

#2

db_connection do |conn|
  @comment_count = conn.exec("SELECT count(*) FROM comments;")
end

@comment_count.each do |count|
  @comment_count_int = count["count"].to_i
end

puts "#{@comment_count_int}"

#3

db_connection do |conn|
  @comments_by_recipe = conn.exec("SELECT count(recipe_id), recipe_id FROM comments GROUP BY recipe_id ORDER BY recipe_id")
end

@comments_by_recipe.each do |each|
  puts "recipe_id: #{each["recipe_id"]} comment count: #{each["count"]}"
end

#4

#comment count by recipe title
# db_connection do |conn|
#   @comments_with_name = conn.exec("SELECT recipes.id, recipes.title, comments.recipe_id, count(comments.recipe_id)
#   FROM recipes, comments
#   WHERE recipes.id = recipe_id
#   GROUP BY comments.recipe_id, recipes.id
#   ORDER BY comments.recipe_id")
# end
#
# @comments_with_name.each do |each|
#    puts "recipe title: #{each["title"]} comment count: #{each["count"]}"
# end

db_connection do |conn|
  @comments_with_name = conn.exec("SELECT recipes.id, recipes.title, comments.recipe_id, comments.comment
  FROM recipes, comments
  WHERE recipes.id = recipe_id
  GROUP BY comments.recipe_id, recipes.id, comments.comment
  ORDER BY comments.recipe_id")
end

@comments_with_name.each do |each|
   puts "recipe title: #{each["title"]} comment: #{each["comment"]}"
end

#5

db_connection do |conn|
  conn.exec_params("INSERT INTO recipes (title)
  VALUES ($1)", ['Brussels Sprouts with Goat Cheese'])
end

db_connection do |conn|
  @recipe_count_2 = conn.exec("SELECT count(*) FROM recipes;")
end

db_connection do |conn|
  2.times do conn.exec_params("INSERT INTO comments (comment, recipe_id)
    VALUES ($1, $2)", [Faker::Lorem.sentence(2), 12])
  end
end

db_connection do |conn|
  @recipe_count = conn.exec("SELECT count(*) FROM recipes;")
end


@recipe_count.each do |count|
  @recipe_count_int = count["count"].to_i
end

puts "#{@recipe_count_int}"

db_connection do |conn|
  @comment_count = conn.exec("SELECT count(*) FROM comments;")
end

@comment_count.each do |count|
  @comment_count_int = count["count"].to_i
end

puts "#{@comment_count_int}"
