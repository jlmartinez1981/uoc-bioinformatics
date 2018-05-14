/**
 * OmicService
 *
 * @class OmicService
 * @description
 */
export class OmicService {

    private static instance: OmicService;

    private nutrigeneticsMap: Map<string, Array<string>>;

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
        this.nutrigeneticsMap = new Map<string, Array<string>>();
        this.fillNutrigeneticsMap();
    }

    private fillNutrigeneticsMap(): void {

        this.nutrigeneticsMap.set('fatty_acid_metabolism', ['APOA2', 'LEPR', 'PPARA', 'ADIPOQ', 'ADIPOA5_1', 'ADIPOA5_2']);

        this.nutrigeneticsMap.set('carbohydrates_metabolism', ['MTNR1B', 'G6PC2', 'FADS1', 'GCK', 'ADRA2A', 'CRY2',
         'GCKR', 'PROX1', 'MADD', 'DGK', 'TMEM', 'TCF7L2', 'SLC30A8', 'CRY2', 'GLIS3', 'ADCY5']);

        this.nutrigeneticsMap.set('salt_sensivity', ['AGT', 'ACE']);

        this.nutrigeneticsMap.set('omega_3_6', ['APAO5', 'FADS1']);

        this.nutrigeneticsMap.set('folate_metabolism', ['MTR', 'MTRR', 'MTHFR', 'MTHFR_1', 'MTHFR_2']);

        this.nutrigeneticsMap.set('injury_prevention', ['COL1A1']);

        this.nutrigeneticsMap.set('lactose_intolerance_risk', ['MCM6']);

        this.nutrigeneticsMap.set('testosterone_optimisation', ['CYP19', 'HSD11B1', 'ACTN3']);

        this.nutrigeneticsMap.set('anti-inflammatory_nutrients', ['CRP', 'IL6', 'GSTP1', 'TNF_Alpha']);

        this.nutrigeneticsMap.set('vitamin_profile', ['FUT2NBPF3', 'FUT2', 'CYP26B1', 'GC', 'CYP2R1_1', 'CYP2R1_2', 'NBPF3', 'BCM01_1', 'BCM01_2', 'SLC23A1', 'SLC23A2']);

        this.nutrigeneticsMap.set('fat_loss_response_to_green_tea', ['COMT']);

        this.nutrigeneticsMap.set('fat_loss', ['FTO', 'ADRB2', 'PPARG', 'PGC1-alpha', 'TFAM']);

        this.nutrigeneticsMap.set('response_to_chromium_picolinate', ['DRD2']);

        this.nutrigeneticsMap.set('caffeine_metabolism', ['ADRA2A', 'CYP1A2']);

        this.nutrigeneticsMap.set('poor_sleep', ['ADORA2A']);

        this.nutrigeneticsMap.set('fatty_liver', ['MTHFD1']);

        this.nutrigeneticsMap.set('glucose-6-phosphate_dehydrogenase_deficiency', ['G6PD']);

        this.nutrigeneticsMap.set('hemochromatosis', ['HFE']);

        this.nutrigeneticsMap.set('sucrase-isomaltase_deficiency', ['SI']);

        this.nutrigeneticsMap.set('hereditary_fructose_intolerance', ['ALDOB']);

        this.nutrigeneticsMap.set('high_alcohol_tolerance', ['ALDH']);

        this.nutrigeneticsMap.set('reduced_ability_to_digest_starch', ['AMY1']);

        this.nutrigeneticsMap.set('bitter_taste_perception_and_decreased_consumption_of_vegetables', ['TAS2R38']);
    }

    public static getInstance(): OmicService {
        if (OmicService.instance) {
            return OmicService.instance;
        }
        return new OmicService();
    }

    public getNutrigeneticsMap(): Map<string, Array<string>> {
        return this.nutrigeneticsMap;
    }

    public getNutrigeneticsFromGenes(genes: Array<string>): object {
        const report: Object = {fileName: undefined, diseases: undefined, nutrigenomics: undefined,
            reportType: undefined};
        // for each map key, go through its values

        return report;
    }
}