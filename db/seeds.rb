random_users = Dir.chdir(File.dirname(__FILE__)) do
  File.open("random_users.json", "r") do |f|
    JSON.parse(f.read)["results"]
  end
end

require 'faker'
require 'ffaker'

puts "Destroying all previous users..."
User.destroy_all

me = User.create!(
  name: "Steve Zelaznik",
  email: "zelaznik@yahoo.com",
  password: "password"
)

random_users.take(30).each_with_index do |data, i|
  begin
    name = [data["name"]["first"], data["name"]["last"]]
    user = User.create!(
      name: "#{name.join(' ')}",
      email: "#{name.join('.')}@jobberwocky.net",
      password: "password"
    )
    identity = Identity.create!(
      user: user,
      provider: "facebook",
      uid: SecureRandom.hex(10),
      name: user.name,
      email: user.email,
      image: data["picture"]["thumbnail"]
    )
    puts "Creating new users #{(100*i/random_users.length).to_i}% complete."
  rescue Exception => e
    puts "Error Creating Fake User: #{e.to_s}"
  end
end

puts "Done creating users!!!"
other_users = User.where("id != ?", me.id)
other_user_count = other_users.count
other_users.each_with_index do |user, i|
  end_time = Time.now
  diff_time = 2.weeks * Random.rand
  start_time = end_time - diff_time
  msg_count = 2 + Random.rand(10)

  alphas = msg_count.times.map { Random.rand }
  pair = [me, user].shuffle
  alphas.sort.each do |a|
    pair.rotate if (Random.rand <= 0.75)
    stamp = start_time + diff_time * a
    Message.create!(
      sender:      pair[0],
      receiver:    pair[1],
      created_at:  stamp,
      updated_at:  stamp,
      body:        Faker::Hacker.say_something_smart
    )
  end
  puts "Creating messages #{(100*i/other_user_count).to_i}% complete."
end
