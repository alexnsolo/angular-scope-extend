gulp = require('gulp')
runSequence = require('run-sequence')
plugins = require('gulp-load-plugins')()


showError = (err) ->
    console.log chalk.red '--------------------------------------------'
    if err.message and err.line and err.file
        console.log chalk.red.bold err.file + ':' + err.line + '\n\n\t' + err.message + '\n'
    else
        console.log chalk.red.bold err
    #END if
    gutil.log('\u0007')
    console.log chalk.red '--------------------------------------------'
    @emit?('end')


gulp.task 'default', -> runSequence('compile', 'minify')

gulp.task 'compile', ->
    gulp.src('angular-scope-extend.coffee')
        .pipe(plugins.plumber(showError))
        .pipe(plugins.coffee())
        .pipe(gulp.dest('./'))

gulp.task 'minify', ->
    gulp.src('angular-scope-extend.js')
        .pipe(plugins.uglifyjs('angular-scope-extend.min.js', outSourceMap: true))
        .pipe(gulp.dest('./'))
