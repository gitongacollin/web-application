document.addEventListener('DOMContentLoaded', function(){
    //Hide flash message after 5 seconds
    const flashMessages = document.querySelectorAll('.flash');
    flashMessages.forEach(message => {
        setTimeout(() => {
            message.style.transition = 'opacity 0.5s ease';
            message.style.opacity = '0';
            setTimeout(() => message.remove(), 500);
        }, 5000);
    });

    //Enhance form validation
    const forms = document.querySelectorAll('form');
    forms.foreach(form => {
        form.addEventListener('submit', function(e){
            const inputs = this.querySelectorAll('input[required], textarea[required]');
            let valid = true;

            inputs.forEach(input => {
                if(!input.value.trim()){
                    valid = false;
                    input.style.borderColor = '#e743c';
                }else {
                    input.style.borderColor = '#ddd';
                }
            });
            if (!valid) {
                e.preventDefault();
                alert('Fill in all required fields.')
            }
        });
    });
});