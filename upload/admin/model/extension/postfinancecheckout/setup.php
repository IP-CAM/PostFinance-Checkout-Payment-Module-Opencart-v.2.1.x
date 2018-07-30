<?php
require_once modification(DIR_SYSTEM . 'library/postfinancecheckout/helper.php');
use PostFinanceCheckout\Model\AbstractModel;

class ModelExtensionPostFinanceCheckoutSetup extends AbstractModel {

	public function install(){
		$this->load->model("extension/postfinancecheckout/migration");
		$this->load->model('extension/postfinancecheckout/modification');
		$this->load->model('extension/postfinancecheckout/dynamic');
		
		$this->model_extension_postfinancecheckout_migration->migrate();
		
		try {
			$this->model_extension_postfinancecheckout_modification->install();
			$this->model_extension_postfinancecheckout_dynamic->install();
		}
		catch (Exception $e) {
		}
		
		$this->addPermissions();
		$this->addEvents();
	}

	public function synchronize($space_id){
		\PostFinanceCheckoutHelper::instance($this->registry)->refreshApiClient();
		\PostFinanceCheckoutHelper::instance($this->registry)->refreshWebhook();
		\PostFinanceCheckout\Service\MethodConfiguration::instance($this->registry)->synchronize($space_id);
	}

	public function uninstall($purge = true){
		$this->load->model("extension/postfinancecheckout/migration");
		$this->load->model('extension/postfinancecheckout/modification');
		$this->load->model('extension/postfinancecheckout/dynamic');
		
		$this->model_extension_postfinancecheckout_dynamic->uninstall();
		if ($purge) {
			$this->model_extension_postfinancecheckout_migration->purge();
		}
		$this->model_extension_postfinancecheckout_modification->uninstall();
		
		$this->removeEvents();
		$this->removePermissions();
	}

	private function addEvents(){
		$this->getEventModel()->addEvent('postfinancecheckout_can_save_order', 'pre.order.edit', 'extension/postfinancecheckout/event/canSaveOrder');
		$this->getEventModel()->addEvent('postfinancecheckout_update_items_after_edit', 'post.order.edit', 'extension/postfinancecheckout/event/update');
		
		//deviceIdentifier, cronScript + refreshWebhook on every page
		// postfinancecheckout_create_dynamic_files handled via modification: Two refreshs required!
		// postfinancecheckout_include_device_identifier handled via modification
		// postfinancecheckout_include_cron_script handled via modification
	}

	private function removeEvents(){
		$this->getEventModel()->deleteEvent('postfinancecheckout_create_dynamic_files');
		$this->getEventModel()->deleteEvent('postfinancecheckout_can_save_order');
		$this->getEventModel()->deleteEvent('postfinancecheckout_update_items_after_edit');
	}

	/**
	 * Adds basic permissions.
	 * Permissions per payment method are added while creating the dynamic files.
	 */
	private function addPermissions(){
		$this->load->model("user/user_group");
		$this->model_user_user_group->addPermission($this->user->getGroupId(), 'access', 'extension/postfinancecheckout/event');
		$this->model_user_user_group->addPermission($this->user->getGroupId(), 'access', 'extension/postfinancecheckout/completion');
		$this->model_user_user_group->addPermission($this->user->getGroupId(), 'access', 'extension/postfinancecheckout/void');
		$this->model_user_user_group->addPermission($this->user->getGroupId(), 'access', 'extension/postfinancecheckout/refund');
		$this->model_user_user_group->addPermission($this->user->getGroupId(), 'access', 'extension/postfinancecheckout/update');
		$this->model_user_user_group->addPermission($this->user->getGroupId(), 'access', 'extension/postfinancecheckout/pdf');
		$this->model_user_user_group->addPermission($this->user->getGroupId(), 'access', 'extension/postfinancecheckout/alert');
	}

	private function removePermissions(){
		$this->load->model("user/user_group");
		$this->model_user_user_group->removePermission($this->user->getGroupId(), 'access', 'extension/postfinancecheckout/event');
		$this->model_user_user_group->removePermission($this->user->getGroupId(), 'access', 'extension/postfinancecheckout/completion');
		$this->model_user_user_group->removePermission($this->user->getGroupId(), 'access', 'extension/postfinancecheckout/void');
		$this->model_user_user_group->removePermission($this->user->getGroupId(), 'access', 'extension/postfinancecheckout/refund');
		$this->model_user_user_group->removePermission($this->user->getGroupId(), 'access', 'extension/postfinancecheckout/update');
		$this->model_user_user_group->removePermission($this->user->getGroupId(), 'access', 'extension/postfinancecheckout/pdf');
		$this->model_user_user_group->removePermission($this->user->getGroupId(), 'access', 'extension/postfinancecheckout/alert');
	}
}