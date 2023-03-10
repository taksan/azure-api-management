import { AzureFunction, Context, HttpRequest } from "@azure/functions"

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<void> {
    context.res = {
        // status: 200, /* Defaults to 200 */
        body: {
            linkedInProfile: {
                first_name: "Bell",
                last_name: "Crane"
            }
        }
    };

};

export default httpTrigger;
