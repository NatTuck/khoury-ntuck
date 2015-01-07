
task :default => [:ship]

task :ship do
  system("jekyll b")
  system("rsync -avz _site/ ntuck@login.ccs.neu.edu:~/www")
end
