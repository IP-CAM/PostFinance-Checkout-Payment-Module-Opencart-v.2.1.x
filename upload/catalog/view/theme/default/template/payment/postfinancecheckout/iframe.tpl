<div class="panel panel-default">
	<div class="panel-heading">
		<h4><?php echo $text_payment_title; ?></h4>
		<span><?php echo $text_further_details; ?></span>
	</div>
	<div style="padding: 15px;">
		<div id="postfinancecheckout-iframe-spinner" class="text-center">
			<i style="font-size: 12em;"
				class='fa fa-spinner fa-spin '></i>
		</div>
		<div id="postfinancecheckout-iframe-container" class="text-center" style="display:none;">
		</div>

		<div class="buttons" style="overflow:hidden;">
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
    function initPostFinanceCheckoutIframe(){
    	if(typeof PostFinanceCheckout === 'undefined') {
    		setTimeout(initPostFinanceCheckoutIframe, 500);
    	} else {
    		PostFinanceCheckout.init('<?php echo $configuration_id; ?>');
    	}
    }
    jQuery().ready(initPostFinanceCheckoutIframe);
    </script>
</div>