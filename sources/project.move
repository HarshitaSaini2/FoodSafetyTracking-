module MyModule::FoodSafetyTracker {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct to represent a food batch with its safety checks.
    struct FoodBatch has store, key {
        batch_id: u64,
        supplier: address,
        safety_checked: bool,
        last_check_timestamp: u64,
    }

    /// Function to create a new food batch record.
    public fun create_batch(owner: &signer, batch_id: u64, supplier: address) {
        let batch = FoodBatch {
            batch_id,
            supplier,
            safety_checked: false,
            last_check_timestamp: 0,
        };
        move_to(owner, batch);
    }

    /// Function to record a food safety check for a specific batch.
    public fun record_safety_check(owner: &signer, batch_owner: address, batch_id: u64, timestamp: u64) acquires FoodBatch {
        let batch = borrow_global_mut<FoodBatch>(batch_owner);

        // Ensure that the batch matches and safety check hasn't been recorded yet
        assert!(batch.batch_id == batch_id, 1); // Ensure batch ID matches
        assert!(!batch.safety_checked, 2); // Ensure safety check is not already recorded

        // Record the safety check details
        batch.safety_checked = true;
        batch.last_check_timestamp = timestamp;
    }
}
