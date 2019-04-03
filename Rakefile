
task :default => [:build]

task :build do
  system("jekyll b")
end

task :sync do
  flags = "-vrlxzich --safe-links --stats --del"
  #flags = "-iacz"

  system("rsync #{flags}  --exclude='/courses/2017' --exclude='/courses/2016' --exclude='/courses/2015' _site/ ntuck@login.ccs.neu.edu:~/www")
  system("ssh ntuck@login.ccs.neu.edu ./fix-perms.sh")
end

task :ship do
  system("rake build")
  system("rake sync")
end
