var gulp = require('gulp');
var stylus = require('gulp-stylus');

var stylusDir = './styles/*.styl'

gulp.task('css', function () {
  gulp.src(stylusDir)
    .pipe(stylus({compress: false}))
    .pipe(gulp.dest('./styles'));
});

gulp.task('watch', function() {
  gulp.watch(stylusDir, ['css'])
});

gulp.task('default', ['watch']);