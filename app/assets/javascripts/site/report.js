$(function(){
  $(document).on("click", 'a[data-widget="report-link"]', function(e){
    e.preventDefault();
    var self = $(this);
    var url = '/watches/';
    var klass = self.data("class");
    var id = self.data("id");
    var data = {watch:{watchable_type:klass, watchable_id:id}};
    $.post(url, data, replace_callback(self.data("replace")), 'json');
  });
  $(document).on("click", 'a[data-widget="unwatch-link"]', function(e){
    e.preventDefault();
    var self = $(this);
    var url = '/watches/' + self.data("id");
    var data = {"_method":"DELETE"};
    $.post(url, data, replace_callback(self.data("replace")), 'json');
  });
});