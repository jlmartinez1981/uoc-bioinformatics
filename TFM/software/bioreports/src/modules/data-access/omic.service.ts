/**
 * OmicService
 *
 * @class OmicService
 * @description
 */
export class OmicService {

    private static instance: OmicService;
    /**
     * Constructor.
     *
     * @class OmicService
     * @constructor
     */
    constructor() {
        if (OmicService.instance) {
            throw 'OmicService instance already exists. Please use OmicService.getInstance()';
        }
    }

    public static getInstance(): OmicService {
        if (OmicService.instance) {
            return OmicService.instance;
        }
        return new OmicService();
    }
}