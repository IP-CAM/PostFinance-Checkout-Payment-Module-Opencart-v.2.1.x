<style>
.panel-heading {
	background-color: initial;
}

.route-checkout-checkout .panel-heading:hover {
	background-color: initial;
}

.postfinancecheckout-container {
	padding: 15px;
}

#postfinancecheckout-iframe-spinner {
	display: none;
	margin: auto;
}
</style>
<div class="panel panel-default">
	<div class="panel-heading">
		<h4><?php echo $text_payment_title; ?></h4>
		<span><?php echo $text_further_details; ?></span>
	</div>
	<div class="postfinancecheckout-container">
		<div id="postfinancecheckout-iframe-spinner" class="text-center">
			<i style="font-size: 12em;" class='fa fa-spinner fa-spin '></i>
		</div>
		<div id="postfinancecheckout-iframe-container" class="text-center"
			style="display: none;"></div>

		<div class="buttons" style="overflow: hidden;">
			<div class="pull-right">
				<input type="button" value="<?php echo $button_confirm; ?>"
					id="button-confirm" class="btn btn-primary"
					data-loading-text="<?php echo $text_loading; ?>" disabled />
			</div>
		</div>
	</div>
	<script type="text/javascript" src="<?php echo $external_js; ?>"></script>
	<script type="text/javascript" src="<?php echo $opencart_js; ?>"></script>
	<script type="text/javascript">
    $('#journal-checkout-confirm-button').attr('disabled', 'disabled');
    if(typeof Window.postfinancecheckoutTimeout !== 'undefined') {
        clearTimeout(Window.postfinancecheckoutTimeout);
    }
	function initAddressUpdates() {
		if(typeof window.addressUpdateEventsSet === 'undefined') {
			window.addressUpdateEventsSet = true;
			function registerAddressUpdates(selector) {
				let fullSelector = 'input[name^="' + selector + '_"]';
				var addressUpdateTimerId;
				$(fullSelector).on('change', function() {
					if(addressUpdateTimerId) {
						clearTimeout(addressUpdateTimerId);
					}
					addressUpdateTimerId = setTimeout(updateAddress, 1000, selector);
				});
				$(fullSelector).on('input', function() {
					if(addressUpdateTimerId) {
						clearTimeout(addressUpdateTimerId);
						addressUpdateTimerId = null;
					}
				});
			}
			
			function updateAddress(selector) {
				let fullSelector = 'input[name^="' + selector + '_"]';
			      $.ajax({
			        cache: false,
			        url: 'index.php?route=extension/postfinancecheckout/address/update&' + $(fullSelector).serialize(),
			        type: 'get',
			        dataType: 'html'
			      }).always(
			      	function() {$(document).trigger('journal_checkout_reload_' + selector); }
			      );
			}
			
			registerAddressUpdates('payment');
			registerAddressUpdates('shipping');
		}
	}
    function initPostFinanceCheckoutIframe(){
        jQuery('#postfinancecheckout-iframe-spinner').css("display", "block");
        if(typeof jQuery === 'undefined' || typeof PostFinanceCheckout === 'undefined') {
            Window.postfinancecheckoutTimeout = setTimeout(initPostFinanceCheckoutIframe, 500);
        } else {
            PostFinanceCheckout.init('<?php echo $configuration_id; ?>');
            initAddressUpdates();
        }
    }
    var checked = $('[data-postfinancecheckout-original-checked=true]').val();
    if(checked && checked.startsWith('postfinancecheckout_')) {
        if (typeof Window.loadCounter === 'undefined') {
            Window.loadCounter = 1;
        } else if (Window.loadCounter == 1) {
            Window.loadCounter++;
        } else if (Window.loadCounter == 2) {
            jQuery().ready(initPostFinanceCheckoutIframe);
        }
    } else {
        jQuery().ready(initPostFinanceCheckoutIframe);
    }
    </script>
</div>
