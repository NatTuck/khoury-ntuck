
task :default => [:build]

task :build do
  system("jekyll b")
end

task :ship do
  system("jekyll b")
  system("rsync -avz --exclude='/courses/2016' --exclude='/courses/2015' _site/ ntuck@login.ccs.neu.edu:~/www")
  system("ssh ntuck@login.ccs.neu.edu ./fix-perms.sh")
end
