# Zaczynamy

    bundle install --path=$HOME/.gems
    cd lib
    bundle exec thin --rackup config.ru -p 3000 start 
