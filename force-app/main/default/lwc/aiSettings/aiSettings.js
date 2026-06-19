import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import getAIProviderSettings from '@salesforce/apex/AISettingsController.getAIProviderSettings';
import testConnection from '@salesforce/apex/AISettingsController.testConnection';
import setPreferredProvider from '@salesforce/apex/AISettingsController.setPreferredProvider';
import getSetupInstructions from '@salesforce/apex/AISettingsController.getSetupInstructions';

export default class AiSettings extends LightningElement {
    @track selectedProvider = '';
    @track currentSettings = null;
    @track providers = [];
    @track isTestingConnection = false;
    @track testResults = null;
    @track showInstructions = false;
    @track setupInstructions = null;

    wiredSettingsResult;

    @wire(getAIProviderSettings)
    wiredSettings(result) {
        this.wiredSettingsResult = result;
        if (result.data) {
            try {
                const settings = JSON.parse(result.data);
                this.currentSettings = settings;
                this.selectedProvider = settings.currentProvider;
                this.providers = settings.availableProviders || [];
            } catch (error) {
                console.error('Error parsing settings:', error);
                this.showToast('Error', 'Failed to load AI settings', 'error');
            }
        } else if (result.error) {
            console.error('Error loading settings:', result.error);
            this.showToast('Error', 'Failed to load AI settings', 'error');
        }
    }

    get currentProviderName() {
        return this.currentSettings?.aiSourceName || 'Loading...';
    }

    get currentStatusBadge() {
        return this.currentSettings?.aiSourceBadge || '🟡 Demo Mode';
    }

    get isLiveMode() {
        return this.currentSettings?.currentMode === 'LIVE';
    }

    get statusClass() {
        return this.isLiveMode ? 'status-badge status-live' : 'status-badge status-demo';
    }

    get providerOptions() {
        return this.providers.map(provider => {
            const isSelected = provider.name === this.selectedProvider;
            return {
                ...provider,
                isSelected: isSelected,
                cardClass: isSelected ? 'provider-card selected' : 'provider-card',
                statusClass: provider.status === 'CONNECTED' ? 'provider-status connected' : 'provider-status not-connected'
            };
        });
    }

    handleProviderChange(event) {
        this.selectedProvider = event.currentTarget.dataset.provider;
    }

    handleSaveSettings() {
        if (!this.selectedProvider) {
            this.showToast('Warning', 'Please select an AI provider', 'warning');
            return;
        }

        setPreferredProvider({ providerName: this.selectedProvider })
            .then(message => {
                this.showToast('Success', message, 'success');
                // Refresh settings
                return refreshApex(this.wiredSettingsResult);
            })
            .catch(error => {
                console.error('Error setting provider:', error);
                this.showToast('Error', 'Failed to save settings: ' + (error.body?.message || error.message), 'error');
            });
    }

    handleTestConnection() {
        if (!this.selectedProvider) {
            this.showToast('Warning', 'Please select an AI provider to test', 'warning');
            return;
        }

        this.isTestingConnection = true;
        this.testResults = null;

        testConnection({ providerName: this.selectedProvider })
            .then(resultJson => {
                const result = JSON.parse(resultJson);
                this.testResults = result;

                if (result.success) {
                    this.showToast('Success',
                        `Connection to ${this.selectedProvider} successful!`,
                        'success');
                } else {
                    this.showToast('Error',
                        `Connection failed: ${result.error}`,
                        'error');
                }
            })
            .catch(error => {
                console.error('Test connection error:', error);
                this.showToast('Error',
                    'Connection test failed: ' + (error.body?.message || error.message),
                    'error');
            })
            .finally(() => {
                this.isTestingConnection = false;
            });
    }

    handleRefreshSettings() {
        return refreshApex(this.wiredSettingsResult)
            .then(() => {
                this.showToast('Success', 'Settings refreshed', 'success');
            })
            .catch(error => {
                console.error('Refresh error:', error);
                this.showToast('Error', 'Failed to refresh settings', 'error');
            });
    }

    handleShowInstructions() {
        if (!this.setupInstructions) {
            getSetupInstructions()
                .then(instructionsJson => {
                    this.setupInstructions = JSON.parse(instructionsJson);
                    this.showInstructions = true;
                })
                .catch(error => {
                    console.error('Error loading instructions:', error);
                    this.showToast('Error', 'Failed to load setup instructions', 'error');
                });
        } else {
            this.showInstructions = true;
        }
    }

    handleCloseInstructions() {
        this.showInstructions = false;
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
}
