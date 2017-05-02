'use strict';

var gulp = require('gulp');
var sass = require('gulp-sass');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var sassUnicode = require('gulp-sass-unicode');

// Include plugins
var plugins = require("gulp-load-plugins")({
	pattern: ['gulp-*', 'gulp.*', 'main-bower-files'],
	replaceString: /\bgulp[\-.]/
});
var dest = './resource-bundles/APTSMD_Kuka.resource/';

gulp.task('js', function() {

	gulp.src([
		'./bower_components/jquery/dist/jquery.min.js',
		'./bower_components/angular/angular.min.js',
		'./node_modules/angular-ui-router/release/angular-ui-router.min.js',
		'./bower_components/angular-sanitize/angular-sanitize.min.js',
		'./bower_components/angular-animate/angular-animate.min.js',
		'./bower_components/bootstrap-sass/assets/javascripts/bootstrap.min.js',
		'./node_modules/angular-ui-bootstrap/dist/ui-bootstrap.js',
		'./node_modules/angular-ui-bootstrap/dist/ui-bootstrap-tpls.js',
		'./bower_components/remarkable-bootstrap-notify/dist/bootstrap-notify.min.js',
		'./bower_components/underscore/underscore-min.js',
		'./bower_components/angular-loading-bar/build/loading-bar.min.js',
		'./bower_components/ladda/spin.min.js',
		'./bower_components/ladda/ladda.min.js',
		'./bower_components/angular-ladda/dist/angular-ladda.min.js'
	])
		.pipe(plugins.concat('kuka.min.js'))
		.pipe(plugins.uglify())
		.pipe(gulp.dest(dest + 'js'));

});

gulp.task('css', function() {

	var cssFiles = ['./resource-bundles/APTSMD_Kuka.resource/css/*'];

	gulp.src(plugins.mainBowerFiles().concat(cssFiles))
		.pipe(plugins.filter('*.css'))
		.pipe(plugins.concat('main.css'))
		.pipe(plugins.uglify())
		.pipe(gulp.dest(dest + 'css'));

});

gulp.task('sass', function () {
  return gulp.src('resource-bundles/APTSMD_Kuka.resource/**/*.scss')
    .pipe(sass({outputStyle: 'compressed'}).on('error', sass.logError))
		.pipe(sassUnicode())
    .pipe(gulp.dest('./resource-bundles/APTSMD_Kuka.resource'));
});

gulp.task('watch', function(){
	gulp.watch('resource-bundles/APTSMD_Kuka.resource/**/*.scss', ['sass']);
})

// Define default destination folder
var dest = 'resource-bundles/APTSMD_Kuka.resource/';
