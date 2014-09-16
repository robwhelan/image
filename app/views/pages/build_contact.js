$('#chosenLinkedIn,#chosenEmail,#chosenPhone').html("");
$('.search').val("");
$('#spinningGif').addClass('hidden');
$('#contactSynthesized').removeClass('hidden');
$('#content').prepend(
	"<%= j render partial: '/contacts/contact_link', :locals => { :contact => @contact} %>");
ga('send', 'pageview', '/contact_synthesized');