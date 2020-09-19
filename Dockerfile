FROM ruby:2.7

WORKDIR /app

COPY . /app

RUN bundle install

EXPOSE 8080

#CMD ["bundle", "exec", "unicorn", "-p", "8080", "-c", "./config/unicorn.rb"]
CMD ["bundle", "exec", "ruby", "app.rb"]

