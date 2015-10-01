// Generated on 2015-02-14 using
// generator-webapp 0.5.1
'use strict';
module.exports = function (grunt) {
  grunt.initConfig({
        //use the copy with source and destination
        copy: {
            bower: {
                files: [
                    { src:'bower_components/default/mod_coronium.lua', dest: 'app/extlib/mod_coronium.lua' },
                    { src:'bower_components/EventDispatcher/EventDispatcher.lua', dest: 'app/extlib/EventDispatcher.lua' },
                    { src:'bower_components/LUA-RFC-4122-UUID-Generator/uuid4.lua', dest: 'app/extlib/uuid4.lua' }
                ]
            }
        }
    });
    //load the copy module
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.registerTask('default', ['copy:bower']);
}
