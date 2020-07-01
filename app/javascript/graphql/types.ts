import gql from 'graphql-tag';
import * as VueApolloComposable from '@vue/apollo-composable';
import * as VueCompositionApi from '@vue/composition-api';
export type Maybe<T> = T | null;
export type ReactiveFunction<TParam> = () => TParam;
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: string;
  String: string;
  Boolean: boolean;
  Int: number;
  Float: number;
  /** DateTime */
  DateTime: any;
};

/** Autogenerated input type of AddBlankSchedule */
export type AddBlankScheduleInput = {
  startAt: Scalars['DateTime'];
  endAt: Scalars['DateTime'];
  occupationId?: Maybe<Scalars['ID']>;
  /** A unique identifier for the client performing the mutation. */
  clientMutationId?: Maybe<Scalars['String']>;
};

/** Autogenerated return type of AddBlankSchedule */
export type AddBlankSchedulePayload = {
  __typename?: 'AddBlankSchedulePayload';
  blankSchedule?: Maybe<Schedule>;
  /** A unique identifier for the client performing the mutation. */
  clientMutationId?: Maybe<Scalars['String']>;
  id: Scalars['ID'];
};


/** Autogenerated input type of EditBlankSchedule */
export type EditBlankScheduleInput = {
  blankScheduleId: Scalars['ID'];
  startAt?: Maybe<Scalars['DateTime']>;
  endAt?: Maybe<Scalars['DateTime']>;
  occupationId?: Maybe<Scalars['ID']>;
  /** A unique identifier for the client performing the mutation. */
  clientMutationId?: Maybe<Scalars['String']>;
};

/** Autogenerated return type of EditBlankSchedule */
export type EditBlankSchedulePayload = {
  __typename?: 'EditBlankSchedulePayload';
  blankSchedule?: Maybe<Schedule>;
  /** A unique identifier for the client performing the mutation. */
  clientMutationId?: Maybe<Scalars['String']>;
  id: Scalars['ID'];
};

/** Autogenerated input type of EditUser */
export type EditUserInput = {
  userId: Scalars['ID'];
  example?: Maybe<Scalars['String']>;
  /** A unique identifier for the client performing the mutation. */
  clientMutationId?: Maybe<Scalars['String']>;
};

/** Autogenerated return type of EditUser */
export type EditUserPayload = {
  __typename?: 'EditUserPayload';
  /** A unique identifier for the client performing the mutation. */
  clientMutationId?: Maybe<Scalars['String']>;
  id: Scalars['ID'];
  user?: Maybe<User>;
};

export type Member = {
  __typename?: 'Member';
  color: Scalars['String'];
  companyName?: Maybe<Scalars['String']>;
  email?: Maybe<Scalars['String']>;
  id: Scalars['ID'];
  name?: Maybe<Scalars['String']>;
  role: Scalars['String'];
};

export type Mutation = {
  __typename?: 'Mutation';
  addBlankSchedule?: Maybe<AddBlankSchedulePayload>;
  editBlankSchedule?: Maybe<EditBlankSchedulePayload>;
  editUser?: Maybe<EditUserPayload>;
  id: Scalars['ID'];
  requestScheduleToIndividualUser?: Maybe<RequestScheduleToIndividualUserPayload>;
  requestScheduleToOccupation?: Maybe<RequestScheduleToOccupationPayload>;
  respondSchedule: RespondSchedulePayload;
};


export type MutationAddBlankScheduleArgs = {
  input: AddBlankScheduleInput;
};


export type MutationEditBlankScheduleArgs = {
  input: EditBlankScheduleInput;
};


export type MutationEditUserArgs = {
  input: EditUserInput;
};


export type MutationRequestScheduleToIndividualUserArgs = {
  input: RequestScheduleToIndividualUserInput;
};


export type MutationRequestScheduleToOccupationArgs = {
  input: RequestScheduleToOccupationInput;
};


export type MutationRespondScheduleArgs = {
  input: RespondScheduleInput;
};

export type Occupation = {
  __typename?: 'Occupation';
  id: Scalars['ID'];
  name?: Maybe<Scalars['String']>;
};

/** The connection type for Occupation. */
export type OccupationConnection = {
  __typename?: 'OccupationConnection';
  /** A list of edges. */
  edges?: Maybe<Array<Maybe<OccupationEdge>>>;
  /** A list of nodes. */
  nodes?: Maybe<Array<Maybe<Occupation>>>;
  /** Information to aid in pagination. */
  pageInfo: PageInfo;
};

/** An edge in a connection. */
export type OccupationEdge = {
  __typename?: 'OccupationEdge';
  /** A cursor for use in pagination. */
  cursor: Scalars['String'];
  /** The item at the end of the edge. */
  node?: Maybe<Occupation>;
};

/** Information about pagination in a connection. */
export type PageInfo = {
  __typename?: 'PageInfo';
  /** When paginating forwards, the cursor to continue. */
  endCursor?: Maybe<Scalars['String']>;
  /** When paginating forwards, are there more items? */
  hasNextPage: Scalars['Boolean'];
  /** When paginating backwards, are there more items? */
  hasPreviousPage: Scalars['Boolean'];
  /** When paginating backwards, the cursor to continue. */
  startCursor?: Maybe<Scalars['String']>;
};

export type Query = {
  __typename?: 'Query';
  blankSchedule?: Maybe<Schedule>;
  currentUser?: Maybe<User>;
  id: Scalars['ID'];
  user?: Maybe<User>;
  users: UserConnection;
};


export type QueryBlankScheduleArgs = {
  blankScheduleId: Scalars['ID'];
};


export type QueryUserArgs = {
  id: Scalars['ID'];
};


export type QueryUsersArgs = {
  after?: Maybe<Scalars['String']>;
  before?: Maybe<Scalars['String']>;
  first?: Maybe<Scalars['Int']>;
  last?: Maybe<Scalars['Int']>;
};

/** Autogenerated input type of RequestScheduleToIndividualUser */
export type RequestScheduleToIndividualUserInput = {
  blankScheduleId: Scalars['ID'];
  occupationId: Scalars['ID'];
  startAt: Scalars['DateTime'];
  endAt: Scalars['DateTime'];
  /** A unique identifier for the client performing the mutation. */
  clientMutationId?: Maybe<Scalars['String']>;
};

/** Autogenerated return type of RequestScheduleToIndividualUser */
export type RequestScheduleToIndividualUserPayload = {
  __typename?: 'RequestScheduleToIndividualUserPayload';
  /** A unique identifier for the client performing the mutation. */
  clientMutationId?: Maybe<Scalars['String']>;
  id: Scalars['ID'];
  schedule?: Maybe<Schedule>;
};

/** Autogenerated input type of RequestScheduleToOccupation */
export type RequestScheduleToOccupationInput = {
  blankScheduleId: Scalars['ID'];
  startAt: Scalars['DateTime'];
  endAt: Scalars['DateTime'];
  /** A unique identifier for the client performing the mutation. */
  clientMutationId?: Maybe<Scalars['String']>;
};

/** Autogenerated return type of RequestScheduleToOccupation */
export type RequestScheduleToOccupationPayload = {
  __typename?: 'RequestScheduleToOccupationPayload';
  /** A unique identifier for the client performing the mutation. */
  clientMutationId?: Maybe<Scalars['String']>;
  id: Scalars['ID'];
  schedule?: Maybe<Schedule>;
};

/** Autogenerated input type of RespondSchedule */
export type RespondScheduleInput = {
  scheduleId: Scalars['ID'];
  isAccept?: Maybe<Scalars['Boolean']>;
  /** A unique identifier for the client performing the mutation. */
  clientMutationId?: Maybe<Scalars['String']>;
};

/** Autogenerated return type of RespondSchedule */
export type RespondSchedulePayload = {
  __typename?: 'RespondSchedulePayload';
  /** A unique identifier for the client performing the mutation. */
  clientMutationId?: Maybe<Scalars['String']>;
  id: Scalars['ID'];
  schedule?: Maybe<Schedule>;
};

export type Schedule = {
  __typename?: 'Schedule';
  endAt?: Maybe<Scalars['DateTime']>;
  id: Scalars['ID'];
  isRequest: Scalars['Boolean'];
  mine: Scalars['Boolean'];
  requester: Member;
  responder: Member;
  startAt?: Maybe<Scalars['DateTime']>;
  status: Scalars['String'];
};

/** The connection type for Schedule. */
export type ScheduleConnection = {
  __typename?: 'ScheduleConnection';
  /** A list of edges. */
  edges?: Maybe<Array<Maybe<ScheduleEdge>>>;
  /** A list of nodes. */
  nodes?: Maybe<Array<Maybe<Schedule>>>;
  /** Information to aid in pagination. */
  pageInfo: PageInfo;
};

/** An edge in a connection. */
export type ScheduleEdge = {
  __typename?: 'ScheduleEdge';
  /** A cursor for use in pagination. */
  cursor: Scalars['String'];
  /** The item at the end of the edge. */
  node?: Maybe<Schedule>;
};

/** Autogenerated return type of Schedules */
export type SchedulesPayload = {
  __typename?: 'SchedulesPayload';
  id: Scalars['ID'];
  schedules: ScheduleConnection;
};


/** Autogenerated return type of Schedules */
export type SchedulesPayloadSchedulesArgs = {
  after?: Maybe<Scalars['String']>;
  before?: Maybe<Scalars['String']>;
  first?: Maybe<Scalars['Int']>;
  last?: Maybe<Scalars['Int']>;
};

export type Subscription = {
  __typename?: 'Subscription';
  id: Scalars['ID'];
  schedules: SchedulesPayload;
};

export type User = {
  __typename?: 'User';
  color: Scalars['String'];
  companyName?: Maybe<Scalars['String']>;
  email?: Maybe<Scalars['String']>;
  id: Scalars['ID'];
  isCompany: Scalars['Boolean'];
  isIndividual: Scalars['Boolean'];
  name?: Maybe<Scalars['String']>;
  occupations: OccupationConnection;
  role: Scalars['String'];
};


export type UserOccupationsArgs = {
  after?: Maybe<Scalars['String']>;
  before?: Maybe<Scalars['String']>;
  first?: Maybe<Scalars['Int']>;
  last?: Maybe<Scalars['Int']>;
};

/** The connection type for User. */
export type UserConnection = {
  __typename?: 'UserConnection';
  /** A list of edges. */
  edges?: Maybe<Array<Maybe<UserEdge>>>;
  /** A list of nodes. */
  nodes?: Maybe<Array<Maybe<User>>>;
  /** Information to aid in pagination. */
  pageInfo: PageInfo;
};

/** An edge in a connection. */
export type UserEdge = {
  __typename?: 'UserEdge';
  /** A cursor for use in pagination. */
  cursor: Scalars['String'];
  /** The item at the end of the edge. */
  node?: Maybe<User>;
};

export type AddBlankScheduleMutationVariables = {
  input: AddBlankScheduleInput;
};


export type AddBlankScheduleMutation = (
  { __typename?: 'Mutation' }
  & { addBlankSchedule?: Maybe<(
    { __typename?: 'AddBlankSchedulePayload' }
    & { blankSchedule?: Maybe<(
      { __typename?: 'Schedule' }
      & Pick<Schedule, 'id' | 'startAt' | 'endAt'>
    )> }
  )> }
);

export type EditBlankScheduleMutationVariables = {
  input: EditBlankScheduleInput;
};


export type EditBlankScheduleMutation = (
  { __typename?: 'Mutation' }
  & { editBlankSchedule?: Maybe<(
    { __typename?: 'EditBlankSchedulePayload' }
    & { blankSchedule?: Maybe<(
      { __typename?: 'Schedule' }
      & Pick<Schedule, 'id' | 'startAt' | 'endAt'>
    )> }
  )> }
);

export type EditUserMutationVariables = {
  input: EditUserInput;
};


export type EditUserMutation = (
  { __typename?: 'Mutation' }
  & { editUser?: Maybe<(
    { __typename?: 'EditUserPayload' }
    & { user?: Maybe<(
      { __typename?: 'User' }
      & Pick<User, 'id' | 'email'>
    )> }
  )> }
);

export type RequestScheduleToIndividualUserMutationVariables = {
  input: RequestScheduleToIndividualUserInput;
};


export type RequestScheduleToIndividualUserMutation = (
  { __typename?: 'Mutation' }
  & { requestScheduleToIndividualUser?: Maybe<(
    { __typename?: 'RequestScheduleToIndividualUserPayload' }
    & { schedule?: Maybe<(
      { __typename?: 'Schedule' }
      & Pick<Schedule, 'id'>
    )> }
  )> }
);

export type RequestScheduleToOccupationMutationVariables = {
  input: RequestScheduleToOccupationInput;
};


export type RequestScheduleToOccupationMutation = (
  { __typename?: 'Mutation' }
  & { requestScheduleToOccupation?: Maybe<(
    { __typename?: 'RequestScheduleToOccupationPayload' }
    & { schedule?: Maybe<(
      { __typename?: 'Schedule' }
      & Pick<Schedule, 'id'>
    )> }
  )> }
);

export type RespondScheduleMutationVariables = {
  input: RespondScheduleInput;
};


export type RespondScheduleMutation = (
  { __typename?: 'Mutation' }
  & { respondSchedule: (
    { __typename?: 'RespondSchedulePayload' }
    & { schedule?: Maybe<(
      { __typename?: 'Schedule' }
      & Pick<Schedule, 'id'>
    )> }
  ) }
);

export type BlankScheduleQueryVariables = {
  blankScheduleId: Scalars['ID'];
};


export type BlankScheduleQuery = (
  { __typename?: 'Query' }
  & { blankSchedule?: Maybe<(
    { __typename?: 'Schedule' }
    & Pick<Schedule, 'id' | 'startAt' | 'endAt' | 'mine' | 'isRequest' | 'status'>
    & { requester: (
      { __typename?: 'Member' }
      & Pick<Member, 'id' | 'name' | 'color' | 'companyName'>
    ) }
  )> }
);

export type CurrentUserQueryVariables = {};


export type CurrentUserQuery = (
  { __typename?: 'Query' }
  & { currentUser?: Maybe<(
    { __typename?: 'User' }
    & Pick<User, 'id' | 'email' | 'role' | 'color' | 'name' | 'companyName' | 'isIndividual' | 'isCompany'>
    & { occupations: (
      { __typename?: 'OccupationConnection' }
      & { nodes?: Maybe<Array<Maybe<(
        { __typename?: 'Occupation' }
        & Pick<Occupation, 'id' | 'name'>
      )>>> }
    ) }
  )> }
);

export type SchedulesSubscriptionSubscriptionVariables = {};


export type SchedulesSubscriptionSubscription = (
  { __typename?: 'Subscription' }
  & { schedules: (
    { __typename?: 'SchedulesPayload' }
    & { schedules: (
      { __typename?: 'ScheduleConnection' }
      & { nodes?: Maybe<Array<Maybe<(
        { __typename?: 'Schedule' }
        & Pick<Schedule, 'id' | 'startAt' | 'endAt' | 'mine' | 'isRequest' | 'status'>
        & { requester: (
          { __typename?: 'Member' }
          & Pick<Member, 'id' | 'name' | 'color' | 'companyName'>
        ) }
      )>>> }
    ) }
  ) }
);


export const AddBlankScheduleDocument = gql`
    mutation addBlankSchedule($input: AddBlankScheduleInput!) {
  addBlankSchedule(input: $input) {
    blankSchedule {
      id
      startAt
      endAt
    }
  }
}
    `;

/**
 * __useAddBlankScheduleMutation__
 *
 * To run a mutation, you first call `useAddBlankScheduleMutation` within a Vue component and pass it any options that fit your needs.
 * When your component renders, `useAddBlankScheduleMutation` returns an object that includes:
 * - A mutate function that you can call at any time to execute the mutation
 * - Several other properties: https://v4.apollo.vuejs.org/api/use-mutation.html#return
 *
 * @param options that will be passed into the mutation, supported options are listed on: https://v4.apollo.vuejs.org/guide-composable/mutation.html#options;
 *
 * @example
 * const { mutate, loading, error, onDone } = useAddBlankScheduleMutation({
 *   variables: {
 *      input: // value for 'input'
 *   },
 * });
 */
export function useAddBlankScheduleMutation(options: VueApolloComposable.UseMutationOptionsWithVariables<AddBlankScheduleMutation, AddBlankScheduleMutationVariables>) {
            return VueApolloComposable.useMutation<AddBlankScheduleMutation, AddBlankScheduleMutationVariables>(AddBlankScheduleDocument, options);
          }
export type AddBlankScheduleMutationCompositionFunctionResult = VueApolloComposable.UseMutationReturn<AddBlankScheduleMutation, AddBlankScheduleMutationVariables>;
export const EditBlankScheduleDocument = gql`
    mutation editBlankSchedule($input: EditBlankScheduleInput!) {
  editBlankSchedule(input: $input) {
    blankSchedule {
      id
      startAt
      endAt
    }
  }
}
    `;

/**
 * __useEditBlankScheduleMutation__
 *
 * To run a mutation, you first call `useEditBlankScheduleMutation` within a Vue component and pass it any options that fit your needs.
 * When your component renders, `useEditBlankScheduleMutation` returns an object that includes:
 * - A mutate function that you can call at any time to execute the mutation
 * - Several other properties: https://v4.apollo.vuejs.org/api/use-mutation.html#return
 *
 * @param options that will be passed into the mutation, supported options are listed on: https://v4.apollo.vuejs.org/guide-composable/mutation.html#options;
 *
 * @example
 * const { mutate, loading, error, onDone } = useEditBlankScheduleMutation({
 *   variables: {
 *      input: // value for 'input'
 *   },
 * });
 */
export function useEditBlankScheduleMutation(options: VueApolloComposable.UseMutationOptionsWithVariables<EditBlankScheduleMutation, EditBlankScheduleMutationVariables>) {
            return VueApolloComposable.useMutation<EditBlankScheduleMutation, EditBlankScheduleMutationVariables>(EditBlankScheduleDocument, options);
          }
export type EditBlankScheduleMutationCompositionFunctionResult = VueApolloComposable.UseMutationReturn<EditBlankScheduleMutation, EditBlankScheduleMutationVariables>;
export const EditUserDocument = gql`
    mutation editUser($input: EditUserInput!) {
  editUser(input: $input) {
    user {
      id
      email
    }
  }
}
    `;

/**
 * __useEditUserMutation__
 *
 * To run a mutation, you first call `useEditUserMutation` within a Vue component and pass it any options that fit your needs.
 * When your component renders, `useEditUserMutation` returns an object that includes:
 * - A mutate function that you can call at any time to execute the mutation
 * - Several other properties: https://v4.apollo.vuejs.org/api/use-mutation.html#return
 *
 * @param options that will be passed into the mutation, supported options are listed on: https://v4.apollo.vuejs.org/guide-composable/mutation.html#options;
 *
 * @example
 * const { mutate, loading, error, onDone } = useEditUserMutation({
 *   variables: {
 *      input: // value for 'input'
 *   },
 * });
 */
export function useEditUserMutation(options: VueApolloComposable.UseMutationOptionsWithVariables<EditUserMutation, EditUserMutationVariables>) {
            return VueApolloComposable.useMutation<EditUserMutation, EditUserMutationVariables>(EditUserDocument, options);
          }
export type EditUserMutationCompositionFunctionResult = VueApolloComposable.UseMutationReturn<EditUserMutation, EditUserMutationVariables>;
export const RequestScheduleToIndividualUserDocument = gql`
    mutation requestScheduleToIndividualUser($input: RequestScheduleToIndividualUserInput!) {
  requestScheduleToIndividualUser(input: $input) {
    schedule {
      id
    }
  }
}
    `;

/**
 * __useRequestScheduleToIndividualUserMutation__
 *
 * To run a mutation, you first call `useRequestScheduleToIndividualUserMutation` within a Vue component and pass it any options that fit your needs.
 * When your component renders, `useRequestScheduleToIndividualUserMutation` returns an object that includes:
 * - A mutate function that you can call at any time to execute the mutation
 * - Several other properties: https://v4.apollo.vuejs.org/api/use-mutation.html#return
 *
 * @param options that will be passed into the mutation, supported options are listed on: https://v4.apollo.vuejs.org/guide-composable/mutation.html#options;
 *
 * @example
 * const { mutate, loading, error, onDone } = useRequestScheduleToIndividualUserMutation({
 *   variables: {
 *      input: // value for 'input'
 *   },
 * });
 */
export function useRequestScheduleToIndividualUserMutation(options: VueApolloComposable.UseMutationOptionsWithVariables<RequestScheduleToIndividualUserMutation, RequestScheduleToIndividualUserMutationVariables>) {
            return VueApolloComposable.useMutation<RequestScheduleToIndividualUserMutation, RequestScheduleToIndividualUserMutationVariables>(RequestScheduleToIndividualUserDocument, options);
          }
export type RequestScheduleToIndividualUserMutationCompositionFunctionResult = VueApolloComposable.UseMutationReturn<RequestScheduleToIndividualUserMutation, RequestScheduleToIndividualUserMutationVariables>;
export const RequestScheduleToOccupationDocument = gql`
    mutation requestScheduleToOccupation($input: RequestScheduleToOccupationInput!) {
  requestScheduleToOccupation(input: $input) {
    schedule {
      id
    }
  }
}
    `;

/**
 * __useRequestScheduleToOccupationMutation__
 *
 * To run a mutation, you first call `useRequestScheduleToOccupationMutation` within a Vue component and pass it any options that fit your needs.
 * When your component renders, `useRequestScheduleToOccupationMutation` returns an object that includes:
 * - A mutate function that you can call at any time to execute the mutation
 * - Several other properties: https://v4.apollo.vuejs.org/api/use-mutation.html#return
 *
 * @param options that will be passed into the mutation, supported options are listed on: https://v4.apollo.vuejs.org/guide-composable/mutation.html#options;
 *
 * @example
 * const { mutate, loading, error, onDone } = useRequestScheduleToOccupationMutation({
 *   variables: {
 *      input: // value for 'input'
 *   },
 * });
 */
export function useRequestScheduleToOccupationMutation(options: VueApolloComposable.UseMutationOptionsWithVariables<RequestScheduleToOccupationMutation, RequestScheduleToOccupationMutationVariables>) {
            return VueApolloComposable.useMutation<RequestScheduleToOccupationMutation, RequestScheduleToOccupationMutationVariables>(RequestScheduleToOccupationDocument, options);
          }
export type RequestScheduleToOccupationMutationCompositionFunctionResult = VueApolloComposable.UseMutationReturn<RequestScheduleToOccupationMutation, RequestScheduleToOccupationMutationVariables>;
export const RespondScheduleDocument = gql`
    mutation respondSchedule($input: RespondScheduleInput!) {
  respondSchedule(input: $input) {
    schedule {
      id
    }
  }
}
    `;

/**
 * __useRespondScheduleMutation__
 *
 * To run a mutation, you first call `useRespondScheduleMutation` within a Vue component and pass it any options that fit your needs.
 * When your component renders, `useRespondScheduleMutation` returns an object that includes:
 * - A mutate function that you can call at any time to execute the mutation
 * - Several other properties: https://v4.apollo.vuejs.org/api/use-mutation.html#return
 *
 * @param options that will be passed into the mutation, supported options are listed on: https://v4.apollo.vuejs.org/guide-composable/mutation.html#options;
 *
 * @example
 * const { mutate, loading, error, onDone } = useRespondScheduleMutation({
 *   variables: {
 *      input: // value for 'input'
 *   },
 * });
 */
export function useRespondScheduleMutation(options: VueApolloComposable.UseMutationOptionsWithVariables<RespondScheduleMutation, RespondScheduleMutationVariables>) {
            return VueApolloComposable.useMutation<RespondScheduleMutation, RespondScheduleMutationVariables>(RespondScheduleDocument, options);
          }
export type RespondScheduleMutationCompositionFunctionResult = VueApolloComposable.UseMutationReturn<RespondScheduleMutation, RespondScheduleMutationVariables>;
export const BlankScheduleDocument = gql`
    query blankSchedule($blankScheduleId: ID!) {
  blankSchedule(blankScheduleId: $blankScheduleId) {
    id
    startAt
    endAt
    mine
    isRequest
    status
    requester {
      id
      name
      color
      companyName
    }
  }
}
    `;

/**
 * __useBlankScheduleQuery__
 *
 * To run a query within a Vue component, call `useBlankScheduleQuery` and pass it any options that fit your needs.
 * When your component renders, `useBlankScheduleQuery` returns an object from Apollo Client that contains result, loading and error properties
 * you can use to render your UI.
 *
 * @param options that will be passed into the query, supported options are listed on: https://v4.apollo.vuejs.org/guide-composable/query.html#options;
 *
 * @example
 * const { result, loading, error } = useBlankScheduleQuery(
 *   {
 *      blankScheduleId: // value for 'blankScheduleId'
 *   }
 * );
 */
export function useBlankScheduleQuery(variables: BlankScheduleQueryVariables | VueCompositionApi.Ref<BlankScheduleQueryVariables> | ReactiveFunction<BlankScheduleQueryVariables>, options: VueApolloComposable.UseQueryOptions<BlankScheduleQuery, BlankScheduleQueryVariables> | VueCompositionApi.Ref<VueApolloComposable.UseQueryOptions<BlankScheduleQuery, BlankScheduleQueryVariables>> | ReactiveFunction<VueApolloComposable.UseQueryOptions<BlankScheduleQuery, BlankScheduleQueryVariables>> = {}) {
            return VueApolloComposable.useQuery<BlankScheduleQuery, BlankScheduleQueryVariables>(BlankScheduleDocument, variables, options);
          }
export type BlankScheduleQueryCompositionFunctionResult = VueApolloComposable.UseQueryReturn<BlankScheduleQuery, BlankScheduleQueryVariables>;
export const CurrentUserDocument = gql`
    query currentUser {
  currentUser {
    id
    email
    role
    color
    name
    companyName
    isIndividual
    isCompany
    occupations {
      nodes {
        id
        name
      }
    }
  }
}
    `;

/**
 * __useCurrentUserQuery__
 *
 * To run a query within a Vue component, call `useCurrentUserQuery` and pass it any options that fit your needs.
 * When your component renders, `useCurrentUserQuery` returns an object from Apollo Client that contains result, loading and error properties
 * you can use to render your UI.
 *
 * @param options that will be passed into the query, supported options are listed on: https://v4.apollo.vuejs.org/guide-composable/query.html#options;
 *
 * @example
 * const { result, loading, error } = useCurrentUserQuery(
 *   {
 *   }
 * );
 */
export function useCurrentUserQuery(options: VueApolloComposable.UseQueryOptions<CurrentUserQuery, CurrentUserQueryVariables> | VueCompositionApi.Ref<VueApolloComposable.UseQueryOptions<CurrentUserQuery, CurrentUserQueryVariables>> | ReactiveFunction<VueApolloComposable.UseQueryOptions<CurrentUserQuery, CurrentUserQueryVariables>> = {}) {
            return VueApolloComposable.useQuery<CurrentUserQuery, undefined>(CurrentUserDocument, undefined, options);
          }
export type CurrentUserQueryCompositionFunctionResult = VueApolloComposable.UseQueryReturn<CurrentUserQuery, CurrentUserQueryVariables>;
export const SchedulesSubscriptionDocument = gql`
    subscription schedulesSubscription {
  schedules {
    schedules {
      nodes {
        id
        startAt
        endAt
        mine
        isRequest
        status
        requester {
          id
          name
          color
          companyName
        }
      }
    }
  }
}
    `;

/**
 * __useSchedulesSubscriptionSubscription__
 *
 * To run a query within a Vue component, call `useSchedulesSubscriptionSubscription` and pass it any options that fit your needs.
 * When your component renders, `useSchedulesSubscriptionSubscription` returns an object from Apollo Client that contains result, loading and error properties
 * you can use to render your UI.
 *
 * @param options that will be passed into the subscription, supported options are listed on: https://v4.apollo.vuejs.org/guide-composable/query.html#options;
 *
 * @example
 * const { result, loading, error } = useSchedulesSubscriptionSubscription(
 *   {
 *   }
 * );
 */
export function useSchedulesSubscriptionSubscription(options: VueApolloComposable.UseSubscriptionOptions<SchedulesSubscriptionSubscription, SchedulesSubscriptionSubscriptionVariables> | VueCompositionApi.Ref<VueApolloComposable.UseSubscriptionOptions<SchedulesSubscriptionSubscription, SchedulesSubscriptionSubscriptionVariables>> | ReactiveFunction<VueApolloComposable.UseSubscriptionOptions<SchedulesSubscriptionSubscription, SchedulesSubscriptionSubscriptionVariables>> = {}) {
          return VueApolloComposable.useSubscription<SchedulesSubscriptionSubscription, undefined>(SchedulesSubscriptionDocument, undefined, options);
        }
export type SchedulesSubscriptionSubscriptionCompositionFunctionResult = VueApolloComposable.UseSubscriptionReturn<SchedulesSubscriptionSubscription, SchedulesSubscriptionSubscriptionVariables>;