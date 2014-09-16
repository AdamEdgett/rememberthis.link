var gulp = require('gulp');

var compass = require('gulp-compass');
var browserSync = require('browser-sync');

var paths = {
  sass: 'public/sass/**/*.scss',
  css: 'public/css/*.css',
  views: ['app/**/*.rb', 'app/views/**/*.haml']
};

gulp.task('compass', function() {
  gulp.src(paths.sass)
  .pipe(compass({
    project: __dirname,
    config_file: 'config.rb',
    css: 'public/css',
    sass: 'public/sass'
  }));
});

gulp.task('inject', function() {
  gulp.src(paths.css)
  .pipe(browserSync.reload({stream:true}));
});

gulp.task('browser-sync', function() {
  browserSync.init(null, {
    open: false
  });
});

gulp.task('bs-reload', function() {
  gulp.src(paths.views)
  .pipe(browserSync.reload({stream:true}));
});

// Rerun the task when a file changes
gulp.task('watch', function() {
  gulp.watch(paths.sass, ['compass', 'inject']);
  gulp.watch(paths.views, ['bs-reload']);
});

gulp.task('build', ['compass']);
gulp.task('default', ['browser-sync', 'watch']);
